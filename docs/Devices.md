# Device List

<table>
<thead>
    <th>ID</th>
    <th>Name</th>
    <th>CHIP</th>
    <th>BOARD</th>
    <th>Board Name</th>
</thead>
    <tbody>
{% for entry in site.data.devices %}
    <tr>
        <td>{{ entry.id }}</td>
        <td>{{ entry.name }}</td>
        <td>{{ entry.chip_id }}</td>
        <td>{{ entry.board_id }}</td>
        <td>{{ entry.board_name }}</td>
    </tr>
{% endfor %}
    </tbody>
</table>