# Visualizing the likelihood function

**Author**: Jonathan Che

**Affiliation**: Ph.D. Statistics student, Harvard University

**Artifact:** [Link to Shiny web app](https://jche.shinyapps.io/likelihood-animation/)

![a gif of my submission](jonathanche_artifact.gif)

**Code:** [Code from repo](jonathanche_code.R)

### Explanation

In statistics and data science, likelihood functions and probability densities can be found almost everywhere. At first glance, they’re quite simple; after all, they’re both just functions. Nonetheless, on many occasions I’ve found myself struggling to understand the relationship between the two. Mathematically, it was clear that I could simply take, say, a Normal density and view it as a function of the mean &mu; instead of *x*. What this *actually* meant on an intuitive level, though, was much less clear.

This Shiny app aims to help students better understand the relationship between densities and likelihoods.

After starting the app, students can randomly draw data points from a standard Normal, which appear as red X’s in the left panel. As points are drawn, the red likelihood function in the right panel changes according to the data, peaking more and more sharply near 0 (the true mean).

Students can then proceed to moving the blue &mu; slider. Playing with the slider allows students to see how the likelihood evaluated at different values of &mu; relates to the probabilities of drawing the given data from a Normal(&mu;, 1) density in the left panel. Long blue segments in the right panel correspond with (multiple) long red segments in the left panel, which shows how maximizing the likelihood is equivalent to finding the most probable Normal(&mu;, 1) distribution for the given data.

Personally, I've found it entertaining to play the "detective game" of adjusting the slider to maximize the lengths of the red lines in the left plot and seeing how well that maximizes the likelihood in the right plot, as it shows how influential extreme values can be. Hopefully others can have fun and learn something with this app as well!
