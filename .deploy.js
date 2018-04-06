// Deploy, validando e execultando commandos para atualizar o 'package'

var patt,
    argsObj = {};
    argsKeys = ['tag'];

process.argv.forEach( function(arg) {
  argsKeys.forEach( function(argKey) {
    patt = RegExp(argKey+"=");
    if (patt.test(arg)) { argsObj[argKey] = arg.replace(patt, ''); }
  })
})

// Para fazer deploy precisamos de uma tag
if ( ! argsObj.tag ) { return console.error('ERROR: atualize a versão para deploy -- tag=x.x.x') }

// ======= Comunicando com o 'system' para execultar os comandos de publish e git push

const { exec } = require('child_process')

var commands = [
  // Update git
  "git tag " + argsObj.tag,
  "git add .",
  "git commit",
  "git push",

  // Publish npm
  "npm version " + argsObj.tag,
  "npm publish",
];

execCommands = function(commands){
  if ( commands.length === 0 ) { return console.log("\nDeploy realizado com sucesso\n"); }
  var command = commands.shift();

  console.log("Executando: " + command)
  exec(command, function(error, stdout, stderr){
    if (error === null) return execCommands(commands);

    console.log(`\n${error}`);
    console.log("ERROR: Deploy falhou\n");
  })
}

execCommands(commands)
