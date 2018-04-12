// How to USE

// Deploy com tag automática
// npm run sc:deploy -- commitMsg='Commit Message'

// Deploy sem commit (para caso já tiver comitado, pois o npm dará erro)
// npm run sc:deploy

// Deploy, validando e execultando commandos para atualizar o 'package'
const { exec } = require('child_process')

var pattKey, pattValue,
    argsObj = {};

process.argv.forEach( function(arg) {
  pattKey   = /\w+=/;
  pattValue = /=(.*)/;

  // verificando se o argumento possui /varName=/
  if ( ! pattKey.test(arg) ) { return; }

  // Guardando o valor da varName=
  argsObj[arg.replace(pattValue, '')] = arg.replace(pattKey, '');
})

var currentVersion = require('./package.json').version

// Para fazer deploy precisamos de uma tag e ela tem que ser maior que a versão do pacote
if ( ! argsObj.tag ) {
  argsObj.tag = parseInt(currentVersion.replace(/\./g, '')) + 1
  argsObj.tag = String(argsObj.tag).split('').join('.')
}

if ( parseInt(currentVersion.replace(/\./g, '')) >= parseInt(argsObj.tag.replace(/\./g, '')) ) {
  return console.log("ERROR: Tag deve ser maior que " + currentVersion + "\n")
}

// ======= Comunicando com o 'system' para execultar os comandos de publish e git push

var
  branch = argsObj.branch || 'master';
  commands = [];

// Git

commands.push({ line: "git add .", skipOnError: true })

if ( argsObj.commitMsg ) {
  commands.push({ line: "git commit -m '" + argsObj.commitMsg + "'", skipOnError: true })
}

commands.push({ line: "git push origin " + branch })
commands.push({ line: "git tag v" + argsObj.tag, skipOnError: true })
commands.push({ line: "git push origin " + argsObj.tag, skipOnError: true })

// Publish npm
commands.push({ line: "npm version " + argsObj.tag, skipOnError: true })
commands.push({ line: "npm publish" })

execCommands = function(commands){
  if ( commands.length === 0 ) { return console.log("\nDeploy realizado com sucesso\n"); }
  var command = commands.shift();

  console.log("Executando: " + command.line)
  exec(command.line, function(error, stdout, stderr){
    if (error === null) return execCommands(commands);

    console.log(`\n${error}`);
    console.log(`\n${stdout}`);

    if ( command.skipOnError ) return execCommands(commands);

    console.log("ERROR: Deploy falhou\n");
  })
}

execCommands(commands)
