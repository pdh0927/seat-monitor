# Generated by Django 4.2.7 on 2024-05-16 05:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("user", "0004_alter_user_username"),
    ]

    operations = [
        migrations.AddField(
            model_name="user",
            name="fcm_token",
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
