github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    mkdir -p $GOPATH/src/k8s.io
    cd $GOPATH/src/k8s.io
    wget https://github.com/kubernetes/kubernetes/archive/v$github_version.zip
    unzip v$github_version.zip
    mv kubernetes-$github_version/ kubernetes
    cd kubernetes
    make
    cd _output/local/bin/linux/ppc64le/
    ls
    mv kubectl kubectl-$github_version
    ./kubectl-$github_version --help

    if [[ $github_version != $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubectl/latest kubectl-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubectl/latest/kubectl-$ftp_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubectl kubectl-$github_version"
        #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubectl/kubectl-$del_version"
    fi
fi
