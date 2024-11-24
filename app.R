#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


library(shiny)
library(shinydashboard)
library(readr)
library(ggplot2)
library(DT)

dataset <- read_csv("C:/Users/Med/Downloads/archive (15)/heart.csv")

ui <- dashboardPage(
  dashboardHeader(title = "Heart Failure Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "home", icon = icon("home")),
      menuItem("Histogramme", tabName = "histogram", icon = icon("bar-chart")),
      menuItem("Nuage de Points", tabName = "scatterplot", icon = icon("chart-line")),
      menuItem("Boxplot", tabName = "boxplot", icon = icon("box")),
      menuItem("Barplot", tabName = "barplot", icon = icon("chart-bar")),
      menuItem("Table de Données", tabName = "data_table", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              h2("Bienvenue sur le Dashboard Heart Failure"),
              p("Utilisez les onglets pour naviguer à travers les analyses.")
      ),
      tabItem(tabName = "histogram",
              fluidRow(
                box(title = "Paramètres de l'Histogramme", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    sliderInput("bins", "Nombre de bins :", 1, 50, 30),
                    selectInput("hist_column", "Colonne :", choices = names(dataset)),
                    textInput("hist_title", "Titre :", "Histogramme de Exemple"),
                    radioButtons("hist_color", "Couleur :", choices = c("blue", "red", "green"))
                ),
                box(title = "Histogramme", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput("histPlot")
                )
              )
      ),
      tabItem(tabName = "scatterplot",
              fluidRow(
                box(title = "Paramètres du Nuage de Points", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    selectInput("x_col", "Colonne X :", choices = names(dataset)),
                    selectInput("y_col", "Colonne Y :", choices = names(dataset)),
                    textInput("scatter_title", "Titre :", "Nuage de Points de Exemple"),
                    radioButtons("scatter_color", "Couleur :", choices = c("yellow", "pink", "grey"))
                ),
                box(title = "Nuage de Points", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput("scatterPlot")
                )
              )
      ),
      tabItem(tabName = "boxplot",
              fluidRow(
                box(title = "Paramètres du Boxplot", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    selectInput("box_x_column", "Variable X :", choices = names(dataset)),
                    selectInput("box_y_column", "Variable Y :", choices = names(dataset)),
                    textInput("box_title", "Titre :", "Boxplot de Exemple"),
                    radioButtons("box_color", "Couleur :", choices = c("orange", "skyblue", "violet"))
                ),
                box(title = "Boxplot", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput("boxPlot")
                )
              )
      ),
      tabItem(tabName = "barplot",
              fluidRow(
                box(title = "Paramètres du Barplot", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    selectInput("bar_column", "Colonne :", choices = names(dataset)),
                    textInput("bar_title", "Titre :", "Barplot de Exemple"),
                    radioButtons("bar_color", "Couleur :", choices = c("wheat", "royalblue", "brown"))
                ),
                box(title = "Barplot", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput("barPlot")
                )
              )
      ),
      tabItem(tabName = "data_table",
              fluidRow(
                box(title = "Table de Données", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    DT::dataTableOutput("dataTable")
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  
  output$histPlot <- renderPlot({
    ggplot(dataset, aes_string(x = input$hist_column)) +
      geom_histogram(bins = input$bins, fill = input$hist_color) +
      labs(title = input$hist_title)
  })
  
  output$scatterPlot <- renderPlot({
    ggplot(dataset, aes_string(x = input$x_col, y = input$y_col)) +
      geom_point(color = input$scatter_color) +
      labs(title = input$scatter_title)
  })
  
  output$boxPlot <- renderPlot({
    ggplot(dataset, aes_string(x = input$box_x_column, y = input$box_y_column)) +
      geom_boxplot(fill = input$box_color) +
      labs(title = input$box_title)
  })
  
  output$barPlot <- renderPlot({
    ggplot(dataset, aes_string(x = input$bar_column)) +
      geom_bar(fill = input$bar_color) +
      labs(title = input$bar_title)
  })
  
  output$dataTable <- DT::renderDataTable({
    DT::datatable(dataset)
  })
}

shinyApp(ui = ui, server = server)
