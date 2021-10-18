using System.Net.Http;
using System.Threading.Tasks;
using Xunit;

namespace ToppingsApi.Tests.HealthChecks
{
    public class BasicHealthCheckTests : IClassFixture<WebTestFixture>
    {
        private HttpClient Client { get; }

        public BasicHealthCheckTests(WebTestFixture factory)
        {
            Client = factory.CreateClient();
        }

        [Fact]
        public async Task HealthCheck_Invoked_Success()
        {
            var response = await Client.GetAsync("/health");

            Assert.True(response.IsSuccessStatusCode);
        }
    }
}
