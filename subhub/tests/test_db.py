# 130     42    68%   79-81, 84-91, 107-109, 136, 139-144, 148-153, 156-164, 167-172
# 121     34    72%   79-81, 97-99, 126, 129-134, 138-143, 146-154, 157-162
from mockito import when, mock, unstub

from subhub.db import _create_account_model
from subhub.db import SubHubAccount, SubHubAccountModel

from pynamodb.exceptions import PutError


def test_create_account_model():
    cls = _create_account_model("table", "region", "https://google.com")
    assert cls.Meta.table_name == "table"
    assert cls.Meta.region == "region"
    assert cls.Meta.host == "https://google.com"


def test_save_user_PutError():
    when(SubHubAccountModel).get("uid").thenRaise(PutError)
    model = _create_account_model("table", "region", "https://google.com")()
    model.user_id = "1"
    model.cust_id = "1"
    model.origin_system = "Firefox"
    SubHubAccount.save_user(model)
