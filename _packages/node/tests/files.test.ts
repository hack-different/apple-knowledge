import {glob} from "glob";
import {promisify} from "util";
import path from "path";

test('there are files', async () => {
    let files = await promisify(glob)(path.resolve(__dirname, '../share/**/*.json'))

    expect(files.length).toBeGreaterThan(10)
})