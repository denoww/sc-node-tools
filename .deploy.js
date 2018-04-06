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

// Para fazer deploy precisamos de uma tag e ela tem que ser maior que a versão do pacote
if ( ! argsObj.tag ) {
  return console.error("ERROR: atualize a versão para deploy -- tag=x.x.x\n")
} else {
  var currentVersion = require('./package.json').version
  if ( parseInt(currentVersion.replace(/\./g, '')) >= parseInt(argsObj.tag.replace(/\./g, '')) ) {
    return console.log("ERROR: Tag deve ser maior que " + currentVersion + "\n")
  }
}

// Para fazer deploy precisamos de uma tag
if ( ! argsObj.msg ) { return console.error("ERROR: passe uma mensagem para seu commit -- msg=Atualizando git\n") }

// ======= Comunicando com o 'system' para execultar os comandos de publish e git push

var
  branch = argsObj.branch || 'master';
  commands = [
    // Update git
    "git add .",
    "git commit -m '" + argsObj.msg + "'",
    "git push origin " + branch,
    "git tag " + argsObj.tag,
    "git push origin " + argsObj.tag,

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
    console.log(`\n${stdout}`);
    console.log("ERROR: Deploy falhou\n");
  })
}

execCommands(commands)
