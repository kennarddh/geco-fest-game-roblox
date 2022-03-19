local projectile = script.Parent

local lifetime = projectile.Configuration.Lifetime.Value

wait(lifetime)

projectile:Destroy()