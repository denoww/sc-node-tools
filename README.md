<h1>Instalação</h1>
    
    $ cd ~/workspace
    $ git clone git@github.com:denoww/sc-node-tools.git

Usando npm:

<pre>
  $ npm i sc-node-tools -s
</pre>

No npm:

<pre>
  require('sc-node-tools')

  scPrint.info('scNodeTools criado com sucesso')
</pre>

<h1>Atualizando pacote</h1>

Logando no npm:

<pre>
  npm login
</pre>

Usando npm script:

<pre>
  // Deploy com tag automática
  $ npm run sc:deploy -- commitMsg='Commit Message'

  // Deploy sem commit (para caso já tiver comitado, pois o npm dará erro)
  $ npm run sc:deploy

  // Atualiznado versão
  $ npm run sc:deploy -- tag=1.0.1
</pre>
