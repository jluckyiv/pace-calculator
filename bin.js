#!/usr/bin/env node

const sade = require("sade");
const pkg = require("./package");

// Link to compiled Elm code main.js
const Elm = require("./src/main").Elm;
const main = Elm.Main.init();

const isSingleCommand = true;

sade("rpace <input>", isSingleCommand)
  .version(pkg.version)
  .describe("Convert arbitrary distances and times to running paces.")
  .example("800m@4:37")
  .example('"800m @ 4:37"')
  .action((input) => {
    main.ports.get.send(input);
    main.ports.put.subscribe(function (data) {
      console.log("  " + data + " minutes per mile\n");
    });
  })
  .parse(process.argv);
