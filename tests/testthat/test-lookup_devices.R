test_that("lookup_devices works when a device has been swapped out", {
  example_paths <- local_example_dir(site_filter = "OB1")
  paths <- lookup_paths(deployment_dir = example_paths$deployment)
  placements <- read_and_format_placements(paths$placements)
  site <- "OB1"
  deployment_date <- "2024-05-21"

  expect_no_error(devices <- lookup_devices(site, deployment_date, placements))
  expect_equal(devices$cond_sn, 21415528) # this is the SN of the device
  # with a 2024-05-21 end date

})
