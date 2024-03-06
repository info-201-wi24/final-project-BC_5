

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview Tab Title",
   h1("Some title"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_1_main_panel <- mainPanel(
  h2("Vizualization 1 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_1_tab <- tabPanel("Viz 1 tab title",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  checkboxGroupInput("county_checkbox", "Select Counties",
                     choices = unique(combined_df$County),
                     selected = unique(combined_df$County)[1]),
)

viz_2_main_panel <- mainPanel(
  h2("WA Counties Ev Adoption"),
  plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_2_tab <- tabPanel("EV vs Gas Cars in WA",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  checkboxGroupInput("checkbox_county", "Select Counties",
                     choices = unique(combined_df$County),
                     selected = unique(combined_df$County)[1]),
)

viz_3_main_panel <- mainPanel(
  h2("Charging Stations Vs EV Use by County"),
  plotlyOutput(outputId = "graph1"),
  plotlyOutput(outputId = "graph2")
)

viz_3_tab <- tabPanel("Charging Stations Vs EV Adoption",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion Tab Title",
 h1("Some title"),
 p("some conclusions")
)



ui <- navbarPage("Example Project Title",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)