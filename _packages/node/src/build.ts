
import * as path from "path";
import {writeFile} from "fs/promises";
import {exec} from "child_process";
import {json} from "stream/consumers";
import {createReadStream} from "fs";
import {parse as parseSemVer, SemVer} from 'semver'
import {glob} from 'glob';
import * as util from "util";
import {parse as parseYaml} from 'yaml';
import * as fs from "fs";
import type { PackageJson } from './package-json'

async function getBranchHeight(branchName: string) : Promise<number> {
    const { stdout } = await util.promisify(exec)('git rev-list --count build')

    const revCount = Number(stdout || "0")

    console.log(`height of branch ${branchName}: ${revCount} commits`)

    return revCount
}

async function updateVersion() : Promise<void> {
    const branchHeight = await getBranchHeight('main')

    const packageFile = path.resolve(process.cwd(), 'package.json')

    let file = createReadStream(packageFile)
    let nodePackage = await json(file) as PackageJson

    let version: SemVer = parseSemVer(nodePackage.version) || new SemVer('1.0.0')

    version.patch = branchHeight

    nodePackage.version = version.format()

    await writeFile(packageFile, JSON.stringify(nodePackage, null, 4))
}

export default async function build() : Promise<void> {
    await updateVersion()

    const dataPath = path.resolve(process.cwd(), '..', '..', 'share')

    const outputPath = path.resolve(process.cwd(), 'share')

    const primaryDataGlob = path.join(dataPath, '**', "*.yaml")

    let dataFiles = await util.promisify(glob)(primaryDataGlob)

    for (const name of dataFiles) {
        let relativePath = path.relative(dataPath, name)
        let outputBaseName = path.basename(relativePath, '.yaml')
        let outputFileName = path.join(path.dirname(relativePath), outputBaseName + '.json')
        console.log(`would have parsed: ${relativePath} to ${outputFileName}`)

        let outputFullPath = path.join(outputPath, outputFileName)
        let outputDirName = path.dirname(outputFullPath)
        await util.promisify(fs.mkdir)(outputDirName, {recursive: true})

        let content = await util.promisify(fs.readFile)(name, "utf-8")
        let document = parseYaml(content)
        let jsonData = JSON.stringify(document, null, 2)
        await writeFile(outputFullPath, jsonData)
    }
}