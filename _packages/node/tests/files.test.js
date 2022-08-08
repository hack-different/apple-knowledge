"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const glob_1 = require("glob");
const util_1 = require("util");
const path_1 = __importDefault(require("path"));
test('there are files', async () => {
    const files_path = path_1.default.resolve(__dirname, '../share/**/*.json');
    console.log(`files path: ${files_path}`);
    let files = await (0, util_1.promisify)(glob_1.glob)(files_path);
    expect(files.length).toBeGreaterThan(10);
});
