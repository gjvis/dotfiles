for file in `ls -Ad .??* | grep -v ^.git$`; do
  ln -s $PWD/$file $HOME/$file
done
