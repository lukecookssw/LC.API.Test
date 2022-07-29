using LukeAPI.Application.TodoLists.Queries.ExportTodos;

namespace LukeAPI.Application.Common.Interfaces;

public interface ICsvFileBuilder
{
    byte[] BuildTodoItemsFile(IEnumerable<TodoItemRecord> records);
}
