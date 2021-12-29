%lang starknet
%builtins pedersen range_check bitwise

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem, assert_not_zero
from starkware.cairo.common.math_cmp import is_nn_le
from starkware.cairo.common.hash_state import hash_init, hash_update, HashState
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from contracts.settling_game.utils.general import scale
from contracts.settling_game.utils.interfaces import IModuleController


from contracts.token.IERC20 import IERC20
from contracts.token.ERC1155.IERC1155 import IERC1155
from contracts.settling_game.realms_IERC721 import realms_IERC721

# #### Module 1A #####
# Base settling contract
# Consumes a Realm
# Sets users stake time
####################

# ########### Game state ############

# Stores the address of the ModuleController.
@storage_var
func controller_address() -> (address : felt):
end


# ########### Admin Functions for Testing ############
# Called on deployment only.
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address_of_controller : felt):
    # Store the address of the only fixed contract in the system.
    controller_address.write(address_of_controller)
    return ()
end


@external
func settle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256):
    alloc_locals
    let (caller) = get_caller_address()
    let (controller) = controller_address.read()
    let (realms_address) = IModuleController.get_realms_address(
        contract_address=controller)

    # # # check owner - TODO be within ERC721
    let (owner) = realms_IERC721.ownerOf(contract_address=realms_address, token_id=token_id)
    assert caller = owner
   
    # # # settle realm state

    # realms_IERC721.settleState(contract_address=realms_address, token_id=token_id, settle_state=1)
    
    # check owner of Realm
    # change erc721 state
    # TODO: add time staked
    return ()
end

@external
func claim_resources{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(realm_id: felt):
    # calculate resources from packed struct
    # add in tax

    # mint resources for user
    # mint reousrces for wonder tax
    return ()
end

@external
func payment_split{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(realm_id: felt):
    # calculate resources from packed struct
    # add in tax

    # mint resources for user
    # mint reousrces for wonder tax
    return ()
end

# Checks write-permission of the calling contract.
func only_approved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Get the address of the module trying to write to this contract.
    let (caller) = get_caller_address()
    let (controller) = controller_address.read()
    # Pass this address on to the ModuleController.
    # "Does this address have write-authority here?"
    # Will revert the transaction if not.
    IModuleController.has_write_access(
        contract_address=controller, address_attempting_to_write=caller)
    return ()
end