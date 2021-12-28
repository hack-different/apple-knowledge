# Device List

<table>
<thead>
    <th>ID</th>
    <th>CHIP</th>
    <th>BOARD</th>
    <th>Board Name</th>
    <th>Description</th>
</thead>
    <tbody>
{% for entry in site.data.devices %}
    <tr>
        <td>{{ entry.id }}</td>
        <td>{{ entry.chip_id }}</td>
        <td>{{ entry.board_id }}</td>
        <td>{{ entry.board_name }}</td>
        <td>{{ entry.description }}</td>
    </tr>
{% endfor %}
    </tbody>
</table>