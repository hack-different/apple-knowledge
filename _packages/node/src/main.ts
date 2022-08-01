import path from "path";
import {readFile} from "fs";
import {promisify} from "util";

export async function getData(dataPath: string) : Promise<any> {
    if (dataPath.endsWith('.yaml')) {
        dataPath = dataPath.slice(0, -5)
    }

    if (!dataPath.endsWith('.json')) {
        dataPath += '.json'
    }

    const data_path = path.resolve(__dirname, '../share', dataPath);
    const data = await promisify(readFile)(data_path, 'utf-8');
    return JSON.parse(data);
}