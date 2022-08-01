import {glob} from "glob";
import {promisify} from "util";
import path from "path";
import {getData} from "../src/main";

test('a file can be loaded', async () => {
    let data = await getData('cores');

    expect(data).toBeDefined();
})