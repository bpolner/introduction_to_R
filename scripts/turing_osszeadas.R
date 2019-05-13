@@ -1,150 +0,0 @@
current_state <- 'None' 
step <- 1 
tape <- c('_') 
position <- 1 

to_ones <- function(input) { 
  output <- c() 
  number <- '' 
  for (char in strsplit(input,'')[[1]]) { 
    if (char == '+') { 
      if (number == ''){ 
        add <- c('*') 
      } else { 
        add <- c(rep('1',as.integer(number)),'*') 
      } 
      output <- c(output,add) 
      number <- '' 
    } else { 
      number = paste0(number,char) 
    } 
  } 
  if (number != ''){ 
    output <- c(output,rep('1',as.integer(number))) 
  }   
  return(output) 
} 

from_ones <- function(input) { 
  output <- '' 
  number <- 0 
  for (item in input) { 
    if (item == '1') { 
      number = number + 1 
    }else if (item == '*') { 
      output <- paste0(output,number,'+') 
      number <- 0 
    } 
  } 
  if (number > 0) { 
    output <- paste0(output,number) 
  } 
  return(output) 
} 

states <- list( 
  'find_star'= list('*'= c('1', 'right', 'find_last'), 
                    '1'= c('1', 'right', 'find_star'), 
                    '_'= c('_', 'right', 'HALT')), 
  'find_last'= list('1'= c('1', 'right', 'find_last'), 
                    '*'= c('*', 'left', 'start_over'), 
                    '_'= c('_', 'left', 'delete_last')), 
  'delete_last'= list('1'=c('_', 'right','delete_last'), 
                      '*'=c('*','left','start_over'), 
                      '_'=c('_', 'left','HALT')), 
  'start_over'=list('1'=c('1','left','start_over'), 
                    '_'=c('_','right','delete_first')), 
  'delete_first'=list('1'=c('_','right','find_star')), 
  'HALT'= "None" 
) 

extend_tape <- function(direction){ 
  if (direction == 'left') { 
    tape <<- c('_',tape) 
    position <<- position + 1 
  } else if (direction == 'right') { 
    tape <<- c(tape,'_') 
  } 
} 

write_pos <- function(position,symbol) { 
  tape[position] <<- symbol 
} 

move <- function(direction) { 
  pos_list <- list('left'=-1,'right'=1) 
  new_pos <- position + pos_list[[direction]] 
  if ((new_pos < 1) | (new_pos > length(tape))) { 
    extend_tape(direction) 
  } 
  position <<- position + pos_list[[direction]] 
} 

tape_str <- function() { 
  s <- '[--' 
  i <- 1 
  for (t in tape) { 
    if (i == position) { 
      join_str <- paste0('(',t,')--') 
    } else { 
      join_str <- paste0(' ',t,' --') 
    } 
    s = paste0(s,join_str) 
    i = i + 1 
  } 
  return(paste0(s,']')) 
} 

command_report <- function(params) { 
  cat(paste0('Step ',step,': Execute ',current_state,' at position',tape_str(), 
             ': write ',params[1],', move ',params[2],', execute ',params[3],'\n')) 
} 

halt <- function() { 
  cat(paste0('Execution ended on step ',step,' (HALT) command.\nFinal state: ',tape_str(),'\n\n')) 
  step <<- 1 
} 

interrupt <- function() { 
  cat(paste0('Execution interrupted (reached step limit).\nFinal state: ',tape_str(),'\n\n')) 
  step <<- 1 
} 

reset <- function() { 
  step <<- 1 
  position <<- 1 
  tape <<- c(0) 
} 

execute_state <- function(state, max_steps) { 
  if (missing(max_steps)) { 
    max_steps <- 'Inf' 
  } 
  while (TRUE) { 
    if (state %in% names(states)) { 
      if (state == 'HALT') { 
        halt() 
        return(tape_str()) 
      } else if (step <= max_steps) { 
        current_state <<- state 
        params <- states[[state]][[toString(tape[position])]] 
        command_report(params) 
        write_pos(position,params[1]) 
        move(params[2]) 
        state <- params[3] 
        step <<- step + 1 
      } else { 
        interrupt() 
        return(tape_str()) 
      } 
    } else { 
      print(paste0('Error: Unknown state: ',state,'!')) 
      return(-1) 
    } 
  } 
} 

tape <- to_ones('3+2+4+6') 
execute_state('find_star') 
result = from_ones(tape)
print(result)
