state <- 'A'
tape <- c('0')
position <- 1
commands <- list('A'=list('0'=list(1,'B'),
                          '1'=list(-1,'C')),
                 'B'=list('0'=list(-1,'A'),
                          '1'=list(1,'B')),
                 'C'=list('0'=list(-1,'B'),
                          '1'=list(1,'HALT')))

# mekkora a lista?
# mi a poz?
# mit kell változtatni?

move <- function(direction){
  if(direction==-1 & position==1){
    tape <<- c('0', tape)
  }else if(direction == 1 & position == length(tape)){
    tape <<- c(tape, '0')
    position <<- position + 1
  }else{
    position <<- position + direction
  }
}

write_one <- function(){
  tape[[position]] <<- '1'
}

change_state <- function(new_state){
  state <<- new_state
}

report <- function(){
  cat(paste0(c('State: ',state,'Position: ', position, '\n', tape, '\n')))
}

execute <- function(){
  report()
  while (state !='HALT'){
    # válatozók: state, position, tape
    # függvények: move, write_one, change_state
    sym <- tape[[position]]
    direction <- commands[[state]][[sym]][[1]]
    next_state <- commands[[state]][[sym]][[2]]
    write_one()
    change_state(next_state)
    move(direction)
    report()
  }
}

execute()
