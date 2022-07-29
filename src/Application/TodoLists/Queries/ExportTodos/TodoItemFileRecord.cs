using LukeAPI.Application.Common.Mappings;
using LukeAPI.Domain.Entities;

namespace LukeAPI.Application.TodoLists.Queries.ExportTodos;

public class TodoItemRecord : IMapFrom<TodoItem>
{
    public string? Title { get; set; }

    public bool Done { get; set; }
}
