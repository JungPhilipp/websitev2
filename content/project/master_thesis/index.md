---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "On the Frame of Reference in Fluid Visualization"
summary: "In my master thesis I explore the dependence of feature extraction techniques, such as vortex core line extraction and time-dependent vector field topology, on the frame the respective frame of reference."
authors:
  - admin
tags:
  - Fluid Visualization

categories: []
date: 2020-02-05T18:29:57+01:00
draft : false

# Optional external URL for project (replaces project detail page).
external_link: ""

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Custom links (optional).
#   Uncomment and edit lines below to show custom links.
# links:
# - name: Follow
#   url: https://twitter.com
#   icon_pack: fab
#   icon: twitter

url_code: ""
url_pdf: "media/MasterThesisPhilippJung.pdf"
url_slides: "media/MasterThesisPhilippJung.pptx"
url_video: ""

# Slides (optional).
#   Associate this project with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides = "example-slides"` references `content/slides/example-slides.md`.
#   Otherwise, set `slides = ""`.
slides: ""
---
Motivated by the developments of objective feature extraction frameworks in the
years 2017/18 [GGT17; GT18a][^1] and 2019 [Had*19][^2] we review the dependence of
vortex core line extraction and time-dependent vector field topology on the respective frame of reference. We compare these frameworks based on their physical interpretability, computation times and quality of resulting features. This includes
an evaluation of the author’s claims that their frameworks can find local frames of
reference in which time-dependent vector fields appear steady. We explore limitations and demonstrate that the birth and death of critical points pose a fundamental
problem for this goal. Our findings establish that the transfer of visualization techniques from the steady to the time-dependent case is only possible if the original
field appears truly steady in the computed frames of reference. We continue to show
that this is a special case, and does not hold for real-world examples. In extension
to this, we show that the extraction of hyperbolic trajectories via parallel vectors
in these frames of reference can mitigate problems related to curved solutions. For
the two-dimensional case, we additionally prove the equivalence of parallel vectors
solutions and critical points in the newly created steady vector field. Moreover, we
demonstrate that invariant manifolds from the steady frame of reference have very
limited meaning for the original vector field.

[^1]: https://dl.acm.org/doi/abs/10.1145/3072959.3073684 https://ieeexplore.ieee.org/abstract/document/8454764
[^2]: https://ieeexplore.ieee.org/abstract/document/8440037
