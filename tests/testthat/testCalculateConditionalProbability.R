context("testCalculateConditionalProbability")

precedingWords <- "hello world wide"
continuations <- c("web", "range", "open")

test_that("weblmCalculateConditionalProbability returns expected result structure", {

  skip_on_cran()

  res <- weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, "title", 4L)

  expect_that(res, is_a("weblm"))
  expect_that(length(res), equals(3))
  expect_that(res[["request"]], is_a("request"))
  expect_that(res[["json"]], is_a("character"))
  expect_that(res[["results"]], is_a("data.frame"))
  expect_that(names(res[["results"]])[1], equals("words"))
  expect_that(names(res[["results"]])[2], equals("word"))
  expect_that(names(res[["results"]])[3], equals("probability"))
})

test_that("weblmCalculateConditionalProbability fails with an error", {

  skip_on_cran()

  # precedingWords: bad, other params: good, expect error
  expect_that(weblmCalculateConditionalProbability(precedingWords = 0, continuations = continuations), throws_error())

  # continuations: bad, other params: good, expect error
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = 0), throws_error())

  # modelToUse: bad, other params: good, expect error
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, modelToUse = "invalid-model"), throws_error())

  # orderOfNgram: bad, other params: good, expect error
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, "title", orderOfNgram = -1), throws_error())

  url <- mscsweblm4r:::weblmGetURL()
  key <- mscsweblm4r:::weblmGetKey()

  # URL: good, key: bad, expect error
  mscsweblm4r:::weblmSetKey("invalid-key")
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, "title", 4L), throws_error())

  # URL: bad, key: bad, expect error
  mscsweblm4r:::weblmSetURL("invalid-URL")
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, "title", 4L), throws_error())

  # URL: bad, key: good, expect error
  mscsweblm4r:::weblmSetKey(key)
  expect_that(weblmCalculateConditionalProbability(precedingWords = precedingWords, continuations = continuations, "title", 4L), throws_error())

  mscsweblm4r:::weblmSetURL(url)
})
