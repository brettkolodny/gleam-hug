import * as fs from "node:fs";

export const readFile = (path) => {
  try {
    const okValue = {};

    okValue[0] = fs.readFileSync(path, "utf-8");
    okValue.isOk = () => true;

    return okValue;
  } catch {
    return new Error();
  }
};
