for file in `ls -Ad .??*`; do
  ln -s $PWD/$file $HOME/$file
done
