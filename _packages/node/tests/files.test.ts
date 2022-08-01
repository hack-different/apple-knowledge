import {glob} from "glob";
import {promisify} from "util";
import path from "path";

test('there are files', async () => {
    const files_path = path.resolve(__dirname, '../share/**/*.json')
    console.log(`files path: ${files_path}`)
    let files = await promisify(glob)(files_path)

    expect(files.length).toBeGreaterThan(10)
})