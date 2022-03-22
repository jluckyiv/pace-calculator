import { test } from "uvu";
import * as assert from "uvu/assert";

const Elm = require("../dist/main").Elm;
const main = Elm.Main.init();

test("elm port should return correct pace", () => {
  main.ports.get.send("800m@4:37");
  main.ports.put.subscribe(function (data) {
    assert.is(data, "9:17");
  });
});

test.run();
