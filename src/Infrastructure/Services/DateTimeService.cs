using LukeAPI.Application.Common.Interfaces;

namespace LukeAPI.Infrastructure.Services;

public class DateTimeService : IDateTime
{
    public DateTime Now => DateTime.Now;
}
