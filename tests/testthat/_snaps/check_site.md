# check_site gives proper messages

    Code
      check_site(site_dir)
    Output
      Site BB_Data/2024/AB2 validated. Result files are up to date.

---

    Code
      check_site(site_dir)
    Output
      *** Errors validating site BB_Data/2024/AB2
      Source files used in the previous run have apparently been deleted. If this was intentional, rerun stitch_site.
      Source files have changed since stitch_site was run. Rerun stitch_site to update.
      Result files are missing. Rerun stitch_site to recreate them.
      Result files have been changed since stitch_site was run. Rerun stitch_site to replace them.
      
                                    file  status
      1 2024-08-16/QC_AB2_2024-08-16.csv      ok
      2            a:/nowhere/not_a_file missing
      3 2024-09-05/QC_AB2_2024-09-05.csv changed
      4    combined/archive_AB2_2024.csv      ok
      5            a:/nowhere/not_a_file missing
      6       combined/core_AB2_2024.csv changed

---

    Code
      check_site(site_dir)
    Output
      *** Hash file BB_Data/2024/AB2/combined/hash.txt is missing.
      Most likely either your path is wrong or stitch_site hasn't been run for this deployment.

