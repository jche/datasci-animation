# Visualizing the likelihood function

**Author**: Jonathan Che

**Affiliation**: Ph.D. Statistics student, Harvard University

**Artifact:** [Link to Shiny web app](https://jche.shinyapps.io/likelihood-animation/)

![a gif of my submission](jonathanche_artifact.gif)

**Code:** [Code from repo](jonathanche_code.R)

### Explanation

In statistics and data science, likelihood functions and probability densities can be found almost everywhere. At first glance, they’re quite simple; after all, they’re both just functions. Nonetheless, on many occasions I’ve found myself struggling to understand the relationship between the two. Mathematically, it was clear that I could simply take, say, a Normal density and view it as a function of the mean &mu; instead of *x*. What this actually meant on an intuitive level, though, was much less clear.

This Shiny app aims to help students better understand the connection between densities and likelihoods, using a simple example with standard Normal data.

After starting the app, students can randomly draw data points from a standard Normal distribution, which appear as red X’s in the left panel. As points are drawn, the red likelihood function in the right panel changes according to the data, peaking more sharply at 0 (the true mean) as more points are drawn.

After generating some points, students can proceed to moving the blue &mu; slider. In the right panel, the slider simply evaluates the likelihood at &mu; using a blue segment, reinforcing the fact that the likelihood is a function of &mu;, with the red data considered as fixed. 

In the left panel, the slider shows what a Normal(&mu;, 1) density would look like. In addition, red vertical lines are drawn from the data-point X’s to visually represent how probable it would be to draw the red data-points from the Normal(&mu;, 1) density selected by the slider.

In essence, the app allows students to manually pick the value of &mu; that maximizes the likelihood function of the generated data, and see what it means in terms of the density of a Normal(&mu;, 1). Playing with the slider shows how long blue segments in the right panel correspond with (multiple) long red segments in the left panel; in other words, high likelihoods at &mu; correspond with large probabilities that the data could have been drawn from a Normal(&mu;, 1).

Finally, the reset button allows students to try generating different random datasets, to see how randomness affects maximum likelihood estimates at low sample sizes.

