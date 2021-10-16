using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace ToppingsApi.HealthChecks;

public class BasicHealthCheck : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        return Task.FromResult(HealthCheckResult.Healthy());
    }
}