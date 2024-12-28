  terraform {
    cloud{
        organization = "chakri-dev-globo"
        workspaces{
            name="chakri-network-dev"
        }
    }
  }