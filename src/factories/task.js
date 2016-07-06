import { factory } from "industry"
import { chain } from "industry-chain"
import { exception } from "industry-exception"
import { include } from "industry-include"
import { instance } from "industry-instance"
import { functions } from "industry-functions"
import { pattern } from "industry-pattern"
import { standard_io } from "industry-standard-io"
import { tasks } from "industry-tasks"
import { init } from "./ext/init"

export default factory()
  .set("exception", exception)
  .set("include", include)
  .set("instance", instance)
  .set("functions", functions)
  .set("pattern", pattern)
  .set("tasks", tasks)
  .set("standard_io", standard_io)
  .set("chain", chain)
  .set("init", init)
