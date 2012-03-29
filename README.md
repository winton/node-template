#NodeTemplate

A node template for new apps.

##Requirements

    gem install stencil
    gem install foreman

##Setup the template

You only have to do this once.

    git clone git@github.com:winton/node_template.git
    cd node_template
    stencil

##Setup a new project

Do this for every new project.

    mkdir my_project
    git init
    stencil node_template

##Install Dependencies

    npm install jake -g
    jake install

##Start Server

    foreman start