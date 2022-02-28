var Web3 = require("web3");
const { addresses } = require("./whiteListed.js");
var web3 = new Web3();
const dotenv = require("dotenv").config();
//console.log(process.env.PRIVATE_KEY);
// file system module to perform file operations
const fs = require("fs");
let data = {};
addresses.forEach(async (e, i) => {
  const messageHash = web3.utils.soliditySha3(e.addr, e.qty_allowed, e.free);

  // Signs the messageHash with a given account
  const signature = await web3.eth.accounts.sign(
    messageHash,
    process.env.PRIVATE_KEY
  );
  //add quantity to signature
  //add data to one big object
  signature["qty_allowed"] = e.qty_allowed;
  signature["free"] = e.free;
  data[e.addr] = signature;

  //output json file as a whole at the end
  if (i + 1 == addresses.length) {
    console.log(data);
    // stringify JSON Object
    var jsonContent = JSON.stringify(data);
    console.log(jsonContent);

    fs.writeFile("./output.json", jsonContent, "utf8", function (err) {
      if (err) {
        console.log("An error occured while writing JSON Object to File.");
        return console.log(err);
      }

      console.log("JSON file has been saved.");
    });
  }
});