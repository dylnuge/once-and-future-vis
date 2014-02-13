# The Once and Future Visualizer
# D3 Visualization Code
# by Dylan Nugent

# Circle colors are random, but look pretty
# Colors from: https://kuler.adobe.com/Ice-Cream-Shoppe-color-theme-3407160/
colors = ["#C33048", "#276168", "#FDCD8D", "#AD705B", "#EB5057"]

# Constants to tweak for style
width = 1000
height = 700
min_radius = 20
max_radius = 100
min_cx = 50
min_cy = 20
max_cx = 980
max_cy = 600

random_color = () ->
    colors[Math.floor(Math.random() * colors.length)]

# Define the D3 plot
plot = d3.select("#vis")
    .append("svg")
    .attr("width", width)
    .attr("height", height)

d3.selection.prototype.moveToFront = () ->
    this.each () ->
        this.parentNode.appendChild(this)

# Define a make_circles function for each chapter
add_circle = (cx, cy, r, label) ->
    plot.append("circle")
        .style("fill", random_color())
        .style("stroke", "gray")
        .attr("cx", cx)
        .attr("cy", cy)
        .attr("r", r)
        .on("mouseover", () ->
            d3.select(this).style("fill", random_color()))
        .on("mouseout", () ->
            d3.select(this).style("fill", random_color()))
    plot.append("svg:text")
        .text(label)
        .attr("text-anchor", "middle")
        .attr("x", cx)
        .attr("y", cy)

get_range_value = (min, max, percent) ->
    min + (percent * (max - min))

gen_word_plot = (word_list, x_start, size) ->
    min_chap_x = x_start
    max_chap_x = x_start + size
    add_circle(
        # CX, based on position in chapter
        get_range_value(min_chap_x, max_chap_x, word.pos),
        # CY, based on uniqueness in novel
        get_range_value(min_cy, max_cy, 1-word.uniqueness),
        # Radius, based on frequency in chapter
        get_range_value(min_radius, max_radius, word.freq),
        # Label, based on word
        word.word
    ) for word in word_list

# Parse the JSON into the visualization
d3.json "data/vis.json", (error, json) ->
    return console.warn error if error
    chapters = json

    # Divide the x range among the chapters
    chapter_size = (max_cx - min_cx)/chapters.length

    # For each chapter generate a word plot
    gen_word_plot(chapter, min_cx+(i*chapter_size), chapter_size) for chapter, i in chapters