using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace ToppingsApi.Tests.Controllers
{
    public class WeatherForcastControllerTests : IClassFixture<WebTestFixture>
    {
        private HttpClient Client { get; }

        public WeatherForcastControllerTests(WebTestFixture factory)
        {
            Client = factory.CreateClient();
        }

        [Fact]
        public async Task Get_WeatherForcast_ReturnsWeatherForecastItems()
        {
            List<WeatherForecast>? forecasts = await Client.GetFromJsonAsync<List<WeatherForecast>>("WeatherForecast");

            Assert.True(forecasts?.Count > 0);
            Assert.True(forecasts!.All(x => !string.IsNullOrWhiteSpace(x.Summary)));
        }
    }
}
