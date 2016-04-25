node {
   stage 'Checkout'
   checkout scm
   
<<<<<<< HEAD
=======
   stage 'Pull Ubuntu'
   sh "docker pull ubuntu:14.04"

>>>>>>> 3f02299e2208139d3761a30b7ced093d979cfcdb
   stage 'Build'
   sh "./build --no-cache" 

   stage 'Push'
   sh "bash -x ./push"   
}
