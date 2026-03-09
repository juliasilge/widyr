# Find the Pearson correlation of a sparse matrix efficiently

Find the Pearson correlation of a sparse matrix. For large sparse matrix
this is more efficient in time and memory than `cor(as.matrix(x))`. Note
that it does not currently work on simple_triplet_matrix objects.

## Usage

``` r
cor_sparse(x)
```

## Source

This code comes from mike on this Stack Overflow answer:
<https://stackoverflow.com/a/9626089/712603>.

## Arguments

- x:

  A matrix, potentially a sparse matrix such as a "dgTMatrix" object
