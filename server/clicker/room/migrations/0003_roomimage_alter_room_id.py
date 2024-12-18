# Generated by Django 4.2.7 on 2023-12-02 18:06

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ("room", "0002_rename_total_seat_room_totalseat"),
    ]

    operations = [
        migrations.CreateModel(
            name="RoomImage",
            fields=[
                ("id", models.AutoField(primary_key=True, serialize=False)),
                ("roomId", models.IntegerField(verbose_name="Room Id")),
                ("image", models.ImageField(upload_to="")),
                (
                    "startedAt",
                    models.DateTimeField(
                        default=django.utils.timezone.now, verbose_name="촬영 시간"
                    ),
                ),
            ],
        ),
        migrations.AlterField(
            model_name="room",
            name="id",
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]
