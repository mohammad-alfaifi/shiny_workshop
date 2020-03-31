# basic math --------------------------------------------------------------

1 + 1

2 - 2

2 * 3

2 / 2

2 ^ 2


# assignments -------------------------------------------------------------

a = 2

a <- 3

a <- "hello"

a <- 1:10


b <- 2
k <- 3

x <- b + k



# data strcture -----------------------------------------------------------

x <- c(1, 2, 3)

x <- c("helllo", "hi")

k <- 1
k <- 1.1

class(x)


x <- list("hello", 1)


y <- list("hi", 2)

k <- list(x,y)


# tibble

df <- data.frame(
  letters = c("A", "B", "C"),
  numbers = c(1, 2, 3)
)



library(tidyverse)


df_tibble <- tibble(
  letters = c("A", "B", "C"),
  numbers = c(1, 2, 3)
)


class(df)

class(df_tibble)


# functions ---------------------------------------------------------------

square_number <- function(x){
  return(x^2)
}

square_number(4)



print_numbers <- function(x, y=2){
  print(x)
  print(y)
}


print_numbers(x = 2, y = 3)

print_numbers(x = 3)



# if  statement -----------------------------------------------------------

a <- 2

if(a == 1){
  print("a = 1")
}else{
  print("a does not equal 1")
}

a <- 5
if(a < 3){
  print("a < 3")
}else{
  print("a > 3")
}


# for loops ---------------------------------------------------------------

x <- c(101 , 33, 60, 60)

for(i in x){
  print(i * 1000)
}

for(i in seq_along(x)){
  print(x[i])
}



# packages ----------------------------------------------------------------

install.packages("tidyverse")

library(tidyverse)

df %>%
  head(2)

df %>%
  tail(1)

df %>%
  View()

# if and if else ----------------------------------------------------------





a <- 5
ifelse(a == 3, print("a < 3"), print("a > 3"))


ifelse(a != 5, "a  = 5 ", "a  != 5")



# tidyverse ---------------------------------------------------------------

library(tidyverse)

d_iris <-
  iris %>%
  as_tibble()

d_iris %>%
  glimpse()


# mutate
d <-
  d_iris %>%
  mutate(
    a = "a",
    b = "b",
    d = "d",
    f = 1,
    m = Sepal.Length + Sepal.Width
  )


# select

d_iris %>%
  select(Sepal.Length, Sepal.Width )

d_iris %>%
  select(-Species)

d_iris %>%
  select_if(is.numeric)


# filter

d_iris %>%
  filter(Species == "setosa" , Petal.Width == 0.2)

#summarise

d_iris %>%
  summarise(
    Sepal_Length_sum = sum(Sepal.Length),
    Sepal.Width_sum = sum(Sepal.Width),
    Sepal_Length_mean = mean(Sepal.Length)
  )
# arrange
d_iris %>%
  arrange(desc(Sepal.Length))

# rename

d_iris %>%
  rename(
    sepal_length = Sepal.Length,
    sepal_width = Sepal.Width
  )


library(janitor)

library(tidylog)

d_iris %>%
  clean_names() %>%
  filter(species == "setosa" , petal_width == 0.2) %>%
  select(-sepal_length) %>%
  rename(sp = species) %>%
  arrange(petal_length )


# pivot long --------------------------------------------------------------

d_cars <-
  mtcars %>%
  as_tibble()

d_cars_long <-
  d_cars %>%
  mutate(index = rownames(.)) %>%
  select(index, everything()) %>%
  pivot_longer(-index)

d_cars_long %>%
  pivot_wider(index)


tibble(
  letter_numbers = paste0(LETTERS, ":", 1:28)
) %>%
  separate(letter_numbers, c("letter", "number"), sep = ":")



# ggplot ------------------------------------------------------------------

d_iris %>%
  clean_names() %>%
  ggplot(aes(x = sepal_length, y = sepal_width))+
  geom_point()+
  labs(
    x = "length",
    y = "width",
    title = "iris dataset"
  )+
  facet_wrap(~species, scales = "free")


# pipe power --------------------------------------------------------------

d_iris %>%
  clean_names() %>%
  filter(species == "setosa" , petal_width == 0.2) %>%
  select(-sepal_length) %>%
  rename(sp = species) %>%
  arrange(petal_length ) %>%
  ggplot(aes(x = sepal_width, y = petal_length))+
  geom_point(col = "steelblue")
