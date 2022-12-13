



#输出时间(时:分:秒)
    time <- function (form = "%H:%M:%S") {
                cat(format(Sys.time(), format = form), "\n")
            }


#将tibble转为数据框(默认前7行)
    headdf <- function(df, i=7, j=NULL){
                if(is(df, "matrix") | is(df, "data.frame") | is(df, "tibble")){
                    if(is.null(j)){
                        output <- df %>% head(i) %>% as.data.frame
                    }else{
                        output <- df[1:i, 1:j] %>% as.data.frame
                    }
                    return(output)
                }else{
                    stop(" Please input the matrix/data.frame/tibble")
                }
            }


#nrow/ncol/colnames/的向量化
    vnrow <- Vectorize(nrow)
    vncol <- Vectorize(ncol)
    vcolnames <- Vectorize(colnames)
    vdim <- function(data=data){lapply(data, dim)}
    vlength <- function(data=data){lapply(data, length)}
    vhead <- function(data=data){lapply(data, head)}


#alias View
    v <- View
