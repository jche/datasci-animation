
# Shiny app to visualize Normal likelihood
# Author: Jonathan Che


#########
# Setup #
#########

# Load required packages
library(shiny)
library(tidyverse)
library(magrittr)

# Define Normal likelihood function
# NOTE: mu passed in and evaluated as vector by default
likelihood <- function(mu, sd = 1, df) {
  temp <- sapply(df$x, function(x) {
    dnorm(x, mean = mu, sd = sd)
  })
  return(prod(temp))
}
# Vectorize likelihood function
# NOTE: forces mu to be passed in item-wise
likelihood_vec <- Vectorize(FUN = likelihood, vectorize.args = "mu")


############
# Shiny UI #
############

ui <- fixedPage(
  # Title
  titlePanel("Visualizing a Normal likelihood"),
  
  hr(),
  
  fixedRow(
    # Button to generate point
    actionButton(
      inputId = "gen_point",
      label = "Draw point from Normal(0,1)",
      style = "color:red"
    )
  ),
  
  fixedRow(
    # Button to reset
    actionButton(
      inputId = "reset",
      label = "Reset points"
    )
  ),
  
  hr(),
  
  fixedRow(
    column(6, align = "center",
           # Density plot
           plotOutput("density", 
                      height = "300px",
                      width = "500px")
    ),
    column(6, align = "center",
           # Likelihood plot
           plotOutput("likelihood", 
                      height = "300px",
                      width = "500px"),
           
           # Slider for mu
           div(style = "margin-left: 22px;", 
               sliderInput(
                 inputId = "mu",
                 # label = HTML("&mu;:"),
                 label = "",
                 min = -4, max = 4, 
                 value = 0, step = 0.25,
                 width = "435px",
                 animate = TRUE))
    )
  ),
  
  # Make slider blue
  # From https://stackoverflow.com/questions/36906265/how-to-color-sliderbar-sliderinput
  tags$style(HTML(
    ".js-irs-0 .irs-single, 
    .js-irs-0 .irs-bar-edge, 
    .js-irs-0 .irs-bar {background: blue}")),
  
  # Make validate error message larger
  tags$head(
    tags$style(HTML(
      ".shiny-output-error-validation {color: #4D4948; font-size: 20px; align: center;}"))),
  
  # Shift slider up
  # From https://github.com/rstudio/shiny/issues/1737
  tags$head(
    tags$style(type="text/css",
               "label.control-label, .selectize-control.single {
               display: table-cell;
               vertical-align: middle;}"))
    )


################
# Shiny server #
################

server <- function(input, output) {
  
  # Reactive data frame for randomly generated points
  values <- reactiveValues(
    df = data.frame("x" = numeric(0), "y" = numeric(0))
  )
  
  # Add point from N(0,1) when gen_point button is clicked
  # x = random draw from N(0,1)
  # y = density of N(mu,1) at x
  observeEvent(input$gen_point,{
    new_point <- rnorm(1, mean = 0, sd = 1)
    x_new <- c(values$df$x, new_point)
    y_new <- c(values$df$y, dnorm(new_point, mean = input$mu, sd = 1))
    values$df <- data.frame(x=x_new, y=y_new)
  })
  
  # Update points when slider is adjusted
  observeEvent(input$mu,{
    values$df %<>%
      mutate(y = dnorm(x, mean = input$mu, sd = 1))
  })
  
  # Reset df when reset button is clicked
  observeEvent(input$reset,{
    values$df <- data.frame(x=numeric(0), y=numeric(0))
  })
  
  # Render density plot
  output$density <- renderPlot({
    ggplot(data.frame(x=0)) +
      stat_function(
        aes(x=x),
        fun = dnorm, 
        args = list(mean = input$mu, sd = 1),
        n = 101, color = "blue", size = 2) +
      # stat_function(
      #   aes(x=x),
      #   fun = dnorm, 
      #   args = list(mean = 0, sd = 1),
      #   n = 101, color = "red", size = 1.5, 
      #   linetype = "dashed", alpha = 0.7) +
      geom_point(
        data = values$df,
        aes(x=x, y=y),
        color = "red", size = 2
      ) +
      geom_point(
        data = values$df,
        aes(x=x, y=rep(0, dim(values$df)[1])),
        color = "red", size = 4, pch = 4
      ) +
      geom_segment(
        data = values$df,
        aes(x=x, xend=x, y=y, yend=rep(0, dim(values$df)[1])),
        color = "red", size = 1, alpha = 0.5
      ) +
      geom_segment(aes(x=-4, xend=4, y=0, yend=0)) +
      xlim(-4, 4) +
      labs(
        title = expression(paste("Density of Normal(", mu, ",1)")),
        x = "x",
        y = ""
      ) +
      theme(text = element_text(size = 20))
  })
  
  # Render likelihood plot
  output$likelihood <- renderPlot({
    # Display message if no points have been generated yet
    validate(need(values$df$y, "\n\n\n\n Generate a point to view the likelihood function of the data!"))
    
    # Likelihood plot
    ggplot(data.frame(x=0), aes(x=x)) +
      stat_function(
        fun = likelihood_vec,
        args = list(df = values$df),
        n = 101, color = "red") +
      geom_point(
        data = data.frame(x=input$mu, y=likelihood_vec(input$mu, df=values$df)),
        aes(x=x, y=y),
        color = "blue", size = 5
      ) +
      geom_segment(
        data = data.frame(x=input$mu, y=likelihood_vec(input$mu, df=values$df)),
        aes(x=x, xend=x, y=y, yend=0),
        color = "blue", size = 2
      ) +
      xlim(-4, 4) +
      labs(
        title = expression(paste("Likelihood of data")),
        x = expression(mu),
        y = ""
      ) +
      theme(
        text = element_text(size = 20),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  })
}


###################
# Run application #
###################

shinyApp(ui = ui, server = server)




#######################################
# gganimate code used to produce .gif #
# (not used for Shiny application)    #
#######################################

# require(gganimate)
# require(tidyverse)
# require(plyr)
# 
# set.seed(2019)
# NUM_OBS <- 5
# 
# # Generate NUM_OBS data points from N(0,1) as if
# # data generation button were clicked NUM_OBS times
# mu <- seq(from = -4, to = 4, by = 0.25)
# points <- rnorm(NUM_OBS, mean = 0, sd = 1)
# df <- data.frame(
#   x = rep(points, length(mu)),
#   mu = rep(mu, each = NUM_OBS)) %>%
#   mutate(
#     y = dnorm(x, mean = mu, sd = 1)
#   )
# 
# # To work with gganimate, build `densities` df to
# # plot densities using geom_line() instead of stat_function()
# grid <- seq(-4, 4, length = 101)
# expanded <- lapply(mu, function(mean) {
#   data.frame(
#     mu = mean,
#     x = grid,
#     density = dnorm(grid, mean = mean, sd = 1)
#   )})
# densities <- rbind.fill(expanded)
# 
# 
# # Animate density plot
# density_plot <- ggplot(df, aes(x=x, y=y)) +
#   geom_line(
#     aes(y=density),
#     data = densities,
#     color = "blue", size = 2) +
#   geom_point(
#     color = "red", size = 2
#   ) +
#   geom_point(
#     aes(x=x, y=rep(0, dim(df)[1])),
#     color = "red", size = 4, pch = 4
#   ) +
#   geom_segment(
#     aes(x=x, xend=x, y=y, yend=rep(0, dim(df)[1])),
#     color = "red", size = 1, alpha = 0.5
#   ) +
#   geom_segment(aes(x=-4, xend=4, y=0, yend=0)) +
#   xlim(-4, 4) +
#   labs(
#     title = expression(paste("Density of Normal(", mu, ",1)")),
#     x = "x",
#     y = ""
#   ) +
#   theme(text = element_text(size = 20)) +
#   transition_states(mu)
# 
# density_plot
# # anim_save("density.gif", animation = density_plot)
# 
# 
# 
# # Define Normal likelihood function
# # NOTE: mu passed in and evaluated as vector by default
# likelihood <- function(mu, sd = 1, df) {
#   temp <- sapply(df$x, function(x) {
#     dnorm(x, mean = mu, sd = sd)
#   })
#   return(prod(temp))
# }
# # Vectorize likelihood function
# # NOTE: forces mu to be passed in item-wise
# likelihood_vec <- Vectorize(FUN = likelihood, vectorize.args = "mu")
# 
# 
# likelihood_df <- data.frame(
#   x = mu,
#   y = likelihood_vec(mu, df = data.frame(x=points))
# )
# 
# # Animate likelihood plot
# likelihood_plot <- ggplot(likelihood_df, aes(x=x, y=y)) +
#   stat_function(
#     fun = likelihood_vec,
#     args = list(df = data.frame(x=points)),
#     n = 1001, color = "red") +
#   geom_point(
#     color = "blue", size = 5
#   ) +
#   geom_segment(
#     aes(x=x, xend=x, y=y, yend=0),
#     color = "blue", size = 2
#   ) +
#   xlim(-4, 4) +
#   labs(
#     title = expression(paste("Likelihood of data")),
#     x = expression(mu),
#     y = ""
#   ) +
#   theme(
#     text = element_text(size = 20),
#     axis.text.y = element_blank(),
#     axis.ticks.y = element_blank()) +
#   transition_states(x)
# 
# likelihood_plot
# # anim_save("likelihood.gif", animation = likelihood_plot)

