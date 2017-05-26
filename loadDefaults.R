
# https://stackoverflow.com/questions/18256568/initializing-function-arguments-in-the-global-environment-r/18257233#18257233
defaults <- function(infunc){
  forms <- formals(infunc)
  for(i in 1:length(forms)){
    if(class(forms[[i]])=="name") next
    assign(names(forms)[i],forms[[i]],envir=globalenv())
  }
}