Here is a summary of the key takeaways included in the file:

### Summary of Reflection Answers Included in the README

1. **`for_each` vs. `count` Safety:** `for_each` relies on immutable, descriptive string keys (like `web1`, `web2`). If you delete a resource from a map, Terraform targets *only* that resource for destruction. `count` relies on ordered index tracking (`[0]`, `[1]`, `[2]`), making it dangerous for dynamic resource structures.

2. **The "Middle-of-the-List" Shifting Problem:** Removing an element from the middle of a list when using `count` causes all subsequent elements to shift left to fill the indexing gap. Terraform interprets this shift as a modification/replacement of existing resources and deletes the final trailing index, resulting in accidental downtime for downstream systems.

3. **Implicit Dependencies (The Best Practice):** Beyond explicit `depends_on` blocks, Terraform builds a Directed Acyclic Graph (DAG) using **implicit dependencies**. Passing the attribute of one resource directly into another (e.g., `vpc_security_group_ids = [aws_security_group.allow_ssh.id]`) automatically signals to Terraform exactly which resource must be built first without cluttering your code.


