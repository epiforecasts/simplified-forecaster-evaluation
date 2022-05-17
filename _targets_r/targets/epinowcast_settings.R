tar_target(epinowcast_settings, {
  list(
    save_warmup = FALSE,
    output_loglik = FALSE,
    pp = FALSE,
    iter_warmup = 1000,
    iter_sampling = 1000,
    chains = 2,
    parallel_chains = 2,
    threads_per_chain = 1,
    adapt_delta = 0.95,
    show_messages = FALSE,
    refresh = 0
  )
})
