local projectile = script.Parent

local lifetime = projectile.Configuration.Lifetime.Value

task.wait(lifetime)

projectile:Destroy()