# Tasktracker

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## My justification of application design
1. data filds of users and tasks table
  users:
    field :email, :string
    field :name, :string

  tasks:
    field :title, :string
    field :descrip, :string
    field :isCompleted, :boolean, default: false
    field :time, :integer, default: 0
    field :user_id_assign, :integer
    field :user_id_create, :integer

  timeblock:
    field :task_id, :integer
    field :start_time, :string
    field :stop_time, :string

2. User operations
  register and login
  create new tasks
  in "unassigned tasks" part: user can edit and assign the tasks(tasks are created by him/herself) to others
  in "uncompleted tasks" part: user can work on tasks assigned to him/her, record spent time and mark it as completed
  in "completed tasks" part: user can review the tasks that are finished by him/her

3. design strategy
  Use MVC concept, the controller(C) utilizes functions of schema context(M) to operate data, then render these data
  into templates(v).

4. User can be managed by multiple managers and can manage multiple underlings. User can also manage him/herself.

5. One task can only be assinged to one user.

6. Use jQuery to update "start/stop" button and insert new timeblock.
