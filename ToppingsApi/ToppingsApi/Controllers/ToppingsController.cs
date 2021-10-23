using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ToppingsApi.Data;

namespace ToppingsApi.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ToppingsController : ControllerBase
    {        
        private ToppingsContext Context { get; }
        private ILogger<ToppingsController> Logger { get; }
        public IConfiguration Config { get; }

        public ToppingsController(ToppingsContext context, 
            ILogger<ToppingsController> logger, IConfiguration config)
        {
            Context = context ?? throw new ArgumentNullException(nameof(context));
            Logger = logger ?? throw new ArgumentNullException(nameof(logger));
            Config = config;
        }


        [HttpGet]
        public async Task<IEnumerable<Topping>> Get()
        {
            using (var sql = new SqlConnection(Config.GetConnectionString("AppsDatabase")))
            {
                sql.Open();
            }
            return await Context.Toppings.ToListAsync();
        }
    }
}
