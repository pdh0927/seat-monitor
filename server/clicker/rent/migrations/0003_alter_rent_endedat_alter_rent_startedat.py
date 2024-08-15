# Generated by Django 4.2.7 on 2023-11-29 12:21

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("rent", "0002_alter_rent_endedat"),
    ]

    operations = [
        migrations.AlterField(
            model_name="rent",
            name="endedAt",
            field=models.DateTimeField(
                default=datetime.datetime(
                    2023, 11, 29, 16, 21, 8, 263068, tzinfo=datetime.timezone.utc
                ),
                verbose_name="반납 시간",
            ),
        ),
        migrations.AlterField(
            model_name="rent",
            name="startedAt",
            field=models.DateTimeField(
                default=datetime.datetime(
                    2023, 11, 29, 12, 21, 8, 262931, tzinfo=datetime.timezone.utc
                ),
                verbose_name="배정 시간",
            ),
        ),
    ]